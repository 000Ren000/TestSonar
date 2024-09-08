﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

// Формирует отчет "Учетные политики организаций" путем выполнения пакета запросов. 
// 
// Параметры:
//   ОсновнаяОрганизация - Справочник.Организации - Организация по которой строится отчет или та организация, с короой происходит сравнение
//   ОрганизацииСравнения - СписокЗначений - Список ссылок на организации, с которыми требуется сравнить настройки учетной политики.
//   ТаблицаОтчета - ТабличныйДокумент - Табличный документ отчета.
//   ПоказатьОтличия - Булево - Если истина, то будут скрываться значения, совпадающие со значениями настройки учетной политиу организации, с короой происходит сравнение 
//
Процедура СформироватьОтчетУчетныеПолитикиОрганизаций(ОсновнаяОрганизация, ОрганизацииСравнения, ТаблицаОтчета, ПоказатьОтличия) Экспорт

	ТаблицаОтчета.АвтоМасштаб = Истина;
	ТаблицаОтчета.ИмяПараметровПечати = "ПАРАМЕТРЫ_ПЕЧАТИ_УЧЕТНАЯПОЛИТИКАОРГАНИЗАЦИЯ";
	
	Макет = ПолучитьМакет("Макет");
	Запрос = Новый Запрос;
	// Установка параметров запроса.
	Если ПоказатьОтличия Тогда
		ОтборПоОрганизациям = ОрганизацииСравнения.ВыгрузитьЗначения();
	Иначе
		ОрганизацииСравнения.Очистить();
		ОтборПоОрганизациям = Новый Массив();
	КонецЕсли;
	
	ОтборПоОрганизациям.Добавить(ОсновнаяОрганизация);
	
	Запрос.УстановитьПараметр("ОсновнаяОрганизация", ОсновнаяОрганизация);
	Запрос.УстановитьПараметр("Период", ТекущаяДатаСеанса());
	Запрос.МенеджерВременныхТаблиц = Новый МенеджерВременныхТаблиц();

	НастройкиНалоговУчетныхПолитик.ДополнитьМенеджерВременныхТаблицГоловнымиОрганизациями(Запрос.МенеджерВременныхТаблиц, ОтборПоОрганизациям);
	
	// Формирование текстов запроса.
	ТекстыЗапроса = Новый СписокЗначений;
	
	ТекстыЗапроса.Добавить(ТекстЗапросаОбщиеНастройки(),	"ОбщиеНастройки");
		
	ТекстыЗапроса.Добавить(ТекстЗапросаНастройкиСистемыНалогообложения(),	"ТаблицаНастройкиСистемыНалогообложения");
	ТекстыЗапроса.Добавить(ТекстЗапросаНастройкиУчетаНДС(),					"ТаблицаНастройкиУчетаНДС");
	
	
	ТекстыЗапроса.Добавить(ТекстЗапросаУчетнаяПолитикаФинансовогоУчета(), "ТаблицаУчетнаяПолитикаФинансовогоУчета");
	
	// Инициализация и вывод таблиц.
	ТаблицыРезультатов = ОбщегоНазначенияУТ.ВыгрузитьРезультатыЗапроса(Запрос, ТекстыЗапроса, ОбходРезультатаЗапроса.ПоГруппировкам);
	
	ВывестиШапкуОтчета(ТаблицаОтчета, Макет, ОрганизацииСравнения, ОсновнаяОрганизация);
	
	Для Каждого ТаблицаРезультата Из ТаблицыРезультатов Цикл 
		ВывестиТаблицуНастройки(ТаблицаОтчета, Макет, ОсновнаяОрганизация, ОрганизацииСравнения, ТаблицаРезультата, ПоказатьОтличия);
	КонецЦикла;
	
КонецПроцедуры

// Добавляет команду отчета в список команд.
// 
// Параметры:
//   КомандыОтчетов - См. ВариантыОтчетовПереопределяемый.ПередДобавлениемКомандОтчетов.КомандыОтчетов
//
Функция ДобавитьКомандуОтчета(КомандыОтчетов) Экспорт

	Если ПравоДоступа("Просмотр", Метаданные.Отчеты.УчетныеПолитикиОрганизаций) Тогда
		
		КомандаОтчет = КомандыОтчетов.Добавить();
		
		КомандаОтчет.Менеджер = Метаданные.Отчеты.УчетныеПолитикиОрганизаций.ПолноеИмя();
		КомандаОтчет.Представление = НСтр("ru = 'Учетная политика организаций'");
		
		КомандаОтчет.МножественныйВыбор = Ложь;
		КомандаОтчет.Важность = "Важное";
		КомандаОтчет.ФункциональныеОпции = "ИспользоватьНесколькоОрганизаций";
		
		Возврат КомандаОтчет;
		
	КонецЕсли;

	Возврат Неопределено;

КонецФункции

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

#Область ТекстыЗапросов

Функция ТекстЗапросаОбщиеНастройки()
	
	ТекстЗапроса = "
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	Организации.Ссылка КАК Организация,
	|	Организации.ВалютаРегламентированногоУчета КАК ВалютаРегламентированногоУчета,
	|	ВЫБОР
	|		КОГДА Организации.Ссылка = &ОсновнаяОрганизация
	|			ТОГДА ИСТИНА
	|		ИНАЧЕ ЛОЖЬ
	|	КОНЕЦ КАК ОсновнаяОрганизация
	|ИЗ
	|	Справочник.Организации КАК Организации
	|ГДЕ
	|	Организации.Ссылка В (ВЫБРАТЬ Организация ИЗ ВтГоловныеОрганизации)
	|
	|УПОРЯДОЧИТЬ ПО
	|	ОсновнаяОрганизация
	|;
	|";
	
	Возврат ТекстЗапроса
	
КонецФункции

Функция ТекстЗапросаНастройкиСистемыНалогообложения()
	
	ТекстЗапроса = "
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	НастройкиСистемыНалогообложенияСрезПоследних.Организация КАК Организация,
	|	НастройкиСистемыНалогообложенияСрезПоследних.СистемаНалогообложения КАК СистемаНалогообложения,
	|	НастройкиСистемыНалогообложенияСрезПоследних.ПрименяетсяЕНВД КАК ПрименяетсяЕНВД,
	|	НастройкиСистемыНалогообложенияСрезПоследних.ЯвляетсяПлательщикомНДПИ КАК ЯвляетсяПлательщикомНДПИ,
	|	НастройкиСистемыНалогообложенияСрезПоследних.ДатаПереходаНаУСН КАК ДатаПереходаНаУСН,
	|	НастройкиСистемыНалогообложенияСрезПоследних.УведомлениеНомерУСН КАК УведомлениеНомерУСН,
	|	НастройкиСистемыНалогообложенияСрезПоследних.УведомлениеДатаУСН КАК УведомлениеДатаУСН,
	|	ВЫБОР
	|		КОГДА НастройкиСистемыНалогообложенияСрезПоследних.Организация = &ОсновнаяОрганизация
	|			ТОГДА ИСТИНА
	|		ИНАЧЕ ЛОЖЬ
	|	КОНЕЦ КАК ОсновнаяОрганизация
	|ИЗ
	|	РегистрСведений.НастройкиСистемыНалогообложения.СрезПоследних(&Период, Организация В (ВЫБРАТЬ Организация ИЗ ВтГоловныеОрганизации)) КАК
	|		НастройкиСистемыНалогообложенияСрезПоследних
	|УПОРЯДОЧИТЬ ПО
	|	ОсновнаяОрганизация
	|;
	|";
	
	Возврат ТекстЗапроса
	
КонецФункции


Функция ТекстЗапросаНастройкиУчетаНДС()
	
	ТекстЗапроса = "
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	НастройкиУчетаНДССрезПоследних.Организация КАК Организация,
	|	ВЫБОР
	|		КОГДА НастройкиУчетаНДССрезПоследних.Организация = &ОсновнаяОрганизация
	|			ТОГДА ИСТИНА
	|		ИНАЧЕ ЛОЖЬ
	|	КОНЕЦ КАК ОсновнаяОрганизация,
	|	НастройкиУчетаНДССрезПоследних.ПрименяетсяУчетНДСПоФактическомуИспользованию,
	|	НастройкиУчетаНДССрезПоследних.ПрименяетсяОсвобождениеОтУплатыНДС,
	|	НастройкиУчетаНДССрезПоследних.РаздельныйУчетТоваровПоНалогообложениюНДС,
	|	НастройкиУчетаНДССрезПоследних.РаздельныйУчетПостатейныхПроизводственныхЗатратПоНалогообложениюНДС,
	|	НастройкиУчетаНДССрезПоследних.УчетНДСДлительногоЦиклаПроизводства,
	|	НастройкиУчетаНДССрезПоследних.Учитывать5ПроцентныйПорог,
	|	НастройкиУчетаНДССрезПоследних.ВариантУчетаНДСПриИзмененииВидаДеятельности,
	|	НастройкиУчетаНДССрезПоследних.СтатьяРасходовНеНДС,
	|	НастройкиУчетаНДССрезПоследних.АналитикаРасходовНеНДС,
	|	НастройкиУчетаНДССрезПоследних.СтатьяРасходовЕНВД,
	|	НастройкиУчетаНДССрезПоследних.АналитикаРасходовЕНВД,
	|	НастройкиУчетаНДССрезПоследних.ПравилоОтбораАвансовДляРегистрацииСчетовФактур,
	|	НастройкиУчетаНДССрезПоследних.УчетНДСВКосмическойДеятельности,
	|	НастройкиУчетаНДССрезПоследних.ФормироватьНДСПредъявленныйПриВключенииВСтоимость,
	|	НастройкиУчетаНДССрезПоследних.ПрименяетсяРасчетНДССМежценовойРазницы,
	|	НастройкиУчетаНДССрезПоследних.РаспределятьНДСВМесяцеОсуществленияКапВложений,
	|	НастройкиУчетаНДССрезПоследних.ПериодичностьФормированияВычетовИВосстановленийНДС
	|ИЗ
	|	РегистрСведений.НастройкиУчетаНДС.СрезПоследних(&Период, Организация В (ВЫБРАТЬ Организация ИЗ ВтГоловныеОрганизации)) КАК НастройкиУчетаНДССрезПоследних
	|УПОРЯДОЧИТЬ ПО
	|	ОсновнаяОрганизация
	|;
	|";
	
	Возврат ТекстЗапроса
	
КонецФункции

Функция ТекстЗапросаУчетнаяПолитикаФинансовогоУчета()
	
	ТекстЗапроса = "
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	УчетнаяПолитикаФинансовогоУчетаСрезПоследних.Организация КАК Организация,
	|	ВЫБОР
	|		КОГДА УчетнаяПолитикаФинансовогоУчетаСрезПоследних.Организация = &ОсновнаяОрганизация
	|			ТОГДА ИСТИНА
	|		ИНАЧЕ ЛОЖЬ
	|	КОНЕЦ КАК ОсновнаяОрганизация,
	|	УчетнаяПолитикаФинансовогоУчетаСрезПоследних.МетодОценкиСтоимостиТоваров,
	|	УчетнаяПолитикаФинансовогоУчетаСрезПоследних.УчетГотовойПродукцииПоПлановойСтоимости,
	|	УчетнаяПолитикаФинансовогоУчетаСрезПоследних.ФормироватьРезервыПоСомнительнымДолгам КАК ФормироватьРезервыПоСомнительнымДолгам,
	|	УчетнаяПолитикаФинансовогоУчетаСрезПоследних.ПериодичностьРезервовПоСомнительнымДолгам КАК ПериодичностьРезервовПоСомнительнымДолгам
	|ИЗ
	|	РегистрСведений.УчетнаяПолитикаФинансовогоУчета.СрезПоследних(&Период, Организация В (ВЫБРАТЬ Организация ИЗ ВтГоловныеОрганизации)) КАК УчетнаяПолитикаФинансовогоУчетаСрезПоследних
	|УПОРЯДОЧИТЬ ПО
	|	ОсновнаяОрганизация
	|;
	|";
	
	Возврат ТекстЗапроса
	
КонецФункции

#КонецОбласти

#Область ВыводДанных

Процедура ВывестиШапкуОтчета(ТаблицаОтчета, Макет, ОрганизацииСравнения, ОсновнаяОрганизация)
	
	Область = Макет.ПолучитьОбласть("Заголовок");
	
	Если КлиентскоеПриложение.ТекущийВариантИнтерфейса() = ВариантИнтерфейсаКлиентскогоПриложения.Такси Тогда
		ОбластьЗаголовок = Область.Области.ОбластьЗаголовок;
		ОбластьЗаголовок.ЦветТекста = ЦветаСтиля.ЦветТекстаЗаголовокОтчетаВТакси;
	КонецЕсли;
	
	ТаблицаОтчета.Вывести(Область);
	
	ИмяОбласти = "Отступ";
	Область = Макет.ПолучитьОбласть(ИмяОбласти);
	ТаблицаОтчета.Вывести(Область);
	
	ИмяОбласти = "Организация";
	Область = Макет.ПолучитьОбласть(ИмяОбласти);
	Область.Параметры.Организация = ОсновнаяОрганизация;
	Область.Параметры.ОрганизацияРасшифровка = ОсновнаяОрганизация;
	ТаблицаОтчета.Присоединить(Область);
	
	Для Каждого Организация Из ОрганизацииСравнения Цикл

		Область.Параметры.Организация = Организация;
		Область.Параметры.ОрганизацияРасшифровка = Организация.Значение;
		ТаблицаОтчета.Присоединить(Область);
			
	КонецЦикла;
	
КонецПроцедуры

Процедура ВывестиТаблицуНастройки(ТаблицаОтчета, Макет, ОсновнаяОрганизация, ОрганизацииСравнения, ТаблицаРезультата, ПоказатьОтличия)
	
	ИмяДанных = СтрЗаменить(ТаблицаРезультата.Ключ, "Таблица", "");
	Если ИмяДанных = "ОбщиеНастройки" Тогда
		Синоним = НСтр("ru = 'Общие настройки'");
		Поля = Метаданные.Справочники.Организации.Реквизиты;
	Иначе
		МенеджерРегистра = Метаданные.РегистрыСведений[ИмяДанных];
		Синоним = МенеджерРегистра.Синоним;
		Поля = МенеджерРегистра.Ресурсы;
	КонецЕсли;
	
	ИмяОбласти = "ОбластьЗаголовокТаблицы";
	Область = Макет.ПолучитьОбласть(ИмяОбласти);
	Область.Параметры.ЗаголовокТаблицы = Синоним;
	Область.Параметры.ЗаголовокТаблицыРасшифровка = ИмяДанных;
	ТаблицаОтчета.Вывести(Область);
	
	ИмяОбласти = "ОтступНастройки";
	Область = Макет.ПолучитьОбласть(ИмяОбласти);
	Если НЕ ОрганизацииСравнения.Количество() Тогда
		Область.ТекущаяОбласть.ГраницаСправа = Новый Линия(ТипЛинииЯчейкиТабличногоДокумента.Сплошная,);
	КонецЕсли;
	
	ТаблицаОтчета.Присоединить(Область);
	
	Для Каждого Организация Из ОрганизацииСравнения Цикл
		Если Организация = ОрганизацииСравнения[ОрганизацииСравнения.Количество()-1] Тогда
			Область.ТекущаяОбласть.ГраницаСправа = Новый Линия(ТипЛинииЯчейкиТабличногоДокумента.Сплошная,);
		КонецЕсли;
		ТаблицаОтчета.Присоединить(Область);
	КонецЦикла; 
	
	БлокТабличногоДокумента = Новый ТабличныйДокумент();
	БлокТабличногоДокумента.НачатьГруппуСтрок();
	
	Область = Макет.ПолучитьОбласть("ОбластьНастройкаОтступ");
	ЧетнаяСтрока = Ложь;
		
	Для Каждого Колонка Из ТаблицаРезультата.Значение.Колонки Цикл
		Если Колонка.Имя <> "Организация" 
				И Колонка.Имя <> "ОсновнаяОрганизация" Тогда
			
			Область.Параметры.Настройка = Поля[Колонка.Имя].Синоним;
			УстановитьЦветФона(Область, ЧетнаяСтрока);
			БлокТабличногоДокумента.Вывести(Область);
			НастройкаОсновнойОрганизации = Неопределено;
			
			МассивВыводимыхОрганизаций = ОрганизацииСравнения.ВыгрузитьЗначения();
			МассивВыводимыхОрганизаций.Вставить(0, ОсновнаяОрганизация);
			
			Для Каждого Организация Из МассивВыводимыхОрганизаций Цикл
				
				НастройкаПоТекущейОрганизации = ТаблицаРезультата.Значение.Строки.Найти(Организация, "Организация");
				ОбластьЗначениеНастройки = Макет.ПолучитьОбласть("ОбластьЗначениеНастройки");
				УстановитьЦветФона(ОбластьЗначениеНастройки, ЧетнаяСтрока, Ложь);
				ТекущаяОрганизацияОсновная = Организация = ОсновнаяОрганизация;
				
				Если Не ЗначениеЗаполнено(НастройкаПоТекущейОрганизации)
					И ТекущаяОрганизацияОсновная Тогда
						НастройкаОсновнойОрганизации = Неопределено;
				КонецЕсли;
				
				Если ЗначениеЗаполнено(НастройкаПоТекущейОрганизации) Тогда
					
					ТекущаяНастройка = НастройкаПоТекущейОрганизации[Колонка.Имя];
					Если ТекущаяОрганизацияОсновная Тогда
						НастройкаОсновнойОрганизации = ТекущаяНастройка;
					КонецЕсли;
				
					Если ТекущаяОрганизацияОсновная И Не ЗначениеЗаполнено(ТекущаяНастройка)
						ИЛИ Не ТекущаяОрганизацияОсновная И ЗначениеЗаполнено(НастройкаОсновнойОрганизации) И Не ЗначениеЗаполнено(ТекущаяНастройка) Тогда
						УстановитьНеЗадано(ОбластьЗначениеНастройки);
					ИначеЕсли Не ПоказатьОтличия
						ИЛИ ТекущаяОрганизацияОсновная
						ИЛИ (ПоказатьОтличия 
						И ТекущаяНастройка <> НастройкаОсновнойОрганизации) Тогда
							ОбластьЗначениеНастройки.Параметры.ЗначениеНастройки = ТекущаяНастройка;
					КонецЕсли;
				ИначеЕсли ТекущаяОрганизацияОсновная
					Или (Не ТекущаяОрганизацияОсновная
					И ЗначениеЗаполнено(НастройкаОсновнойОрганизации)
					И Не ЗначениеЗаполнено(НастройкаПоТекущейОрганизации)) Тогда
					УстановитьНеЗадано(ОбластьЗначениеНастройки);
				КонецЕсли;
				
				БлокТабличногоДокумента.Присоединить(ОбластьЗначениеНастройки);
			КонецЦикла;
			
		КонецЕсли;
	КонецЦикла;
	
	БлокТабличногоДокумента.ЗакончитьГруппуСтрок();
	
	ТаблицаОтчета.Вывести(БлокТабличногоДокумента);
	
КонецПроцедуры

Процедура УстановитьНеЗадано(Область)
	
	Область.Параметры.ЗначениеНастройки = НСтр("ru='<не задано>'", ОбщегоНазначения.КодОсновногоЯзыка());
	Область.ТекущаяОбласть.ЦветТекста = WebЦвета.СветлоСерый;
	
КонецПроцедуры

Процедура УстановитьЦветФона(Область, ЧетнаяСтрока, СледующаяСтрока = Истина)
	
		Если СледующаяСтрока И ЧетнаяСтрока 
			ИЛИ Не СледующаяСтрока И Не ЧетнаяСтрока Тогда
			ЦветФона = ЦветаСтиля.АльтернативныйЦветФонаПоля;
		Иначе
			ЦветФона = ЦветаСтиля.ЦветФонаПоля;
		КонецЕсли;
	
		Если Область.Области.Найти("ОбластьНастройка") <> Неопределено Тогда
			Область.Области["ОбластьНастройка"].ЦветФона = ЦветФона;
		Иначе
			Область.ТекущаяОбласть.ЦветФона = ЦветФона;
		КонецЕсли;
		
		Если СледующаяСтрока Тогда
			ЧетнаяСтрока = НЕ ЧетнаяСтрока;
		КонецЕсли;
	
КонецПроцедуры
	
#КонецОбласти

#КонецОбласти

#КонецЕсли