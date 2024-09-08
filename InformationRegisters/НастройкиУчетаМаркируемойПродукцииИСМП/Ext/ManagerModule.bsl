﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область СлужебныйПрограммныйИнтерфейс

// Начальное заполнение даты начала обязательного учета маркируемой продукции
// 
// Параметры:
// 	ВидМаркируемойПродукции - ПеречислениеСсылка.ВидыПродукцииИС - Вид маркируемой продукции.
// Возвращаемое значение:
// 	Дата - Дата начала учета.
Функция ДатаНачалаУчетаМаркируемойПродукции(ВидМаркируемойПродукции) Экспорт
	
	Если ВидМаркируемойПродукции = Перечисления.ВидыПродукцииИС.Табак Тогда
		
		Возврат '20190301';
		
	ИначеЕсли ВидМаркируемойПродукции = Перечисления.ВидыПродукцииИС.Обувь Тогда
		
		Возврат '20200701';
		
	ИначеЕсли ВидМаркируемойПродукции = Перечисления.ВидыПродукцииИС.ЛегкаяПромышленность Тогда
		
		Возврат '20210101';
		
	ИначеЕсли ВидМаркируемойПродукции = Перечисления.ВидыПродукцииИС.МолочнаяПродукцияПодконтрольнаяВЕТИС Тогда
		
		Возврат '20200301';
		
	ИначеЕсли ВидМаркируемойПродукции = Перечисления.ВидыПродукцииИС.МолочнаяПродукцияБезВЕТИС Тогда
		
		Возврат '20200301';
		
	ИначеЕсли ВидМаркируемойПродукции = Перечисления.ВидыПродукцииИС.Шины Тогда
		
		Возврат '20201101';
		
	ИначеЕсли ВидМаркируемойПродукции = Перечисления.ВидыПродукцииИС.Фотоаппараты Тогда
		
		Возврат '20201001';
	
	ИначеЕсли ВидМаркируемойПродукции = Перечисления.ВидыПродукцииИС.Велосипеды Тогда
		
		Возврат '20200601';
	
	ИначеЕсли ВидМаркируемойПродукции = Перечисления.ВидыПродукцииИС.КреслаКоляски Тогда
		
		Возврат '20210601';
		
	ИначеЕсли ВидМаркируемойПродукции = Перечисления.ВидыПродукцииИС.Духи Тогда
		
		Возврат '20201001';
		
	ИначеЕсли ВидМаркируемойПродукции = Перечисления.ВидыПродукцииИС.АльтернативныйТабак Тогда
		
		Возврат '20200701';
		
	ИначеЕсли ВидМаркируемойПродукции = Перечисления.ВидыПродукцииИС.УпакованнаяВода Тогда
		
		Возврат '20210301';
		
	ИначеЕсли ВидМаркируемойПродукции = Перечисления.ВидыПродукцииИС.Антисептики Тогда
		
		Возврат '20220901';
		
	ИначеЕсли ВидМаркируемойПродукции = Перечисления.ВидыПродукцииИС.БАДы Тогда
		
		Возврат '20220901';
		
	ИначеЕсли ВидМаркируемойПродукции = Перечисления.ВидыПродукцииИС.НикотиносодержащаяПродукция Тогда
		
		Возврат '20220901';
		
	ИначеЕсли ВидМаркируемойПродукции = Перечисления.ВидыПродукцииИС.Пиво Тогда
		
		Возврат '20220901';
	
	ИначеЕсли ВидМаркируемойПродукции = Перечисления.ВидыПродукцииИС.ПродукцияИзНатуральногоМеха Тогда
		
		Возврат '20220901';
		
	ИначеЕсли ВидМаркируемойПродукции = Перечисления.ВидыПродукцииИС.СоковаяПродукция Тогда
		
		Возврат '20230301';
		
	ИначеЕсли ВидМаркируемойПродукции = Перечисления.ВидыПродукцииИС.БезалкогольноеПиво Тогда
		
		Возврат '20230301';
		
	ИначеЕсли ВидМаркируемойПродукции = Перечисления.ВидыПродукцииИС.МорепродуктыПодконтрольныеВЕТИС Тогда
		
		Возврат '20240101';
		
	ИначеЕсли ВидМаркируемойПродукции = Перечисления.ВидыПродукцииИС.КормаДляЖивотныхПодконтрольныеВЕТИС
		Или ВидМаркируемойПродукции = Перечисления.ВидыПродукцииИС.КормаДляЖивотныхБезВЕТИС
		Или ВидМаркируемойПродукции = Перечисления.ВидыПродукцииИС.КонсервированнаяПродукцияПодконтрольнаяВЕТИС
		Или ВидМаркируемойПродукции = Перечисления.ВидыПродукцииИС.КонсервированнаяПродукцияБезВЕТИС
		Или ВидМаркируемойПродукции = Перечисления.ВидыПродукцииИС.РастительныеМасла
		Или ВидМаркируемойПродукции = Перечисления.ВидыПродукцииИС.ВетеринарныеПрепараты Тогда
		
		Возврат '20240901';
		
	ИначеЕсли ВидМаркируемойПродукции = Перечисления.ВидыПродукцииИС.ПарфюмерныеИКосметическиеСредстваИБытоваяХимия
		Или ВидМаркируемойПродукции = Перечисления.ВидыПродукцииИС.РадиоэлектроннаяПродукция Тогда
		
		Возврат '20250301';
		
	ИначеЕсли ВидМаркируемойПродукции = Перечисления.ВидыПродукцииИС.ИгрыИИгрушкиДляДетей
		Или ВидМаркируемойПродукции = Перечисления.ВидыПродукцииИС.ОптоволокноИОптоволоконнаяПродукция Тогда
		
		Возврат '20241202';
		
	ИначеЕсли ВидМаркируемойПродукции = Перечисления.ВидыПродукцииИС.ТитановаяМеталлопродукция Тогда
		
		Возврат '20240401';
		
	ИначеЕсли ВидМаркируемойПродукции = Перечисления.ВидыПродукцииИС.МясоПодконтрольноеВЕТИС Тогда
		
		Возврат '20260101';
		
	КонецЕсли;
	
КонецФункции

// Начальное заполнение даты начала действия разрешительного режима маркируемой продукции
// 
// Параметры:
// 	ВидМаркируемойПродукции - ПеречислениеСсылка.ВидыПродукцииИС - Вид маркируемой продукции.
// Возвращаемое значение:
// 	Дата - Дата начала действия разрешительного режима.
Функция ДатаНачалаДействияРазрешительногоРежимаНаККТ(ВидМаркируемойПродукции) Экспорт
	
	Если ВидМаркируемойПродукции = Перечисления.ВидыПродукцииИС.Табак Тогда
		
		Возврат '20240401';
		
	ИначеЕсли ВидМаркируемойПродукции = Перечисления.ВидыПродукцииИС.Обувь Тогда
		
		Возврат '20241101';
		
	ИначеЕсли ВидМаркируемойПродукции = Перечисления.ВидыПродукцииИС.ЛегкаяПромышленность Тогда
		
		Возврат '20241101';
		
	ИначеЕсли ВидМаркируемойПродукции = Перечисления.ВидыПродукцииИС.МолочнаяПродукцияПодконтрольнаяВЕТИС Тогда
		
		Возврат '20240501';
		
	ИначеЕсли ВидМаркируемойПродукции = Перечисления.ВидыПродукцииИС.МолочнаяПродукцияБезВЕТИС Тогда
		
		Возврат '20240501';
		
	ИначеЕсли ВидМаркируемойПродукции = Перечисления.ВидыПродукцииИС.Шины Тогда
		
		Возврат '20241101';
		
	ИначеЕсли ВидМаркируемойПродукции = Перечисления.ВидыПродукцииИС.Фотоаппараты Тогда
		
		Возврат '20241101';

	ИначеЕсли ВидМаркируемойПродукции = Перечисления.ВидыПродукцииИС.Духи Тогда
		
		Возврат '20241101';
		
	ИначеЕсли ВидМаркируемойПродукции = Перечисления.ВидыПродукцииИС.АльтернативныйТабак Тогда
		
		Возврат '20240401';
		
	ИначеЕсли ВидМаркируемойПродукции = Перечисления.ВидыПродукцииИС.УпакованнаяВода Тогда
		
		Возврат '20240501';
		
	ИначеЕсли ВидМаркируемойПродукции = Перечисления.ВидыПродукцииИС.Антисептики Тогда
		
		Возврат '20241101';
		
	ИначеЕсли ВидМаркируемойПродукции = Перечисления.ВидыПродукцииИС.БАДы Тогда
		
		Возврат '20241101';
		
	ИначеЕсли ВидМаркируемойПродукции = Перечисления.ВидыПродукцииИС.НикотиносодержащаяПродукция Тогда
		
		Возврат '20240401';
		
	ИначеЕсли ВидМаркируемойПродукции = Перечисления.ВидыПродукцииИС.Пиво Тогда
		
		Возврат '20240401';
		
	ИначеЕсли ВидМаркируемойПродукции = Перечисления.ВидыПродукцииИС.СоковаяПродукция Тогда
		
		Возврат '20250205';
		
	ИначеЕсли ВидМаркируемойПродукции = Перечисления.ВидыПродукцииИС.БезалкогольноеПиво Тогда
		
		Возврат '20250205';
		
	КонецЕсли;
	
КонецФункции

Процедура ЗаписатьНастройкуУчетаВидаПродукции(НастройкаУчета, Отказ, ЗапуститьФоновоеОбновлениеНастроекРазрешительногоРежима = Ложь) Экспорт
	
	УстановитьПривилегированныйРежим(Истина);
	
	НаборЗаписей = СоздатьНаборЗаписей();
	НаборЗаписей.Отбор.ВидПродукции.Установить(НастройкаУчета.ВидПродукции);
	
	НаборЗаписей.Прочитать();
	
	Если НаборЗаписей.Количество() = 0 Тогда
		
		СтрокаНабора = НаборЗаписей.Добавить();
		ЗаполнитьЗначенияСвойств(СтрокаНабора, НастройкаУчета);
		
		СтрокаНабора.ДатаОбязательнойМаркировки                      = ДатаНачалаУчетаМаркируемойПродукции(НастройкаУчета.ВидПродукции);
		СтрокаНабора.ДатаОбязательногоВключенияРазрешительногоРежима = ДатаНачалаДействияРазрешительногоРежимаНаККТ(НастройкаУчета.ВидПродукции);
		
		НастройкаУчета.ДатаОбязательнойМаркировки                      = СтрокаНабора.ДатаОбязательнойМаркировки;
		НастройкаУчета.ДатаОбязательногоВключенияРазрешительногоРежима = СтрокаНабора.ДатаОбязательногоВключенияРазрешительногоРежима;
		
	Иначе
		
		СтрокаНабора = НаборЗаписей.Получить(0);
		ЗаполнитьЗначенияСвойств(СтрокаНабора, НастройкаУчета);
		
	КонецЕсли;
	
	Если Не ЗначениеЗаполнено(НастройкаУчета.ДатаОбязательнойМаркировки) Тогда
		
		СтрокаНабора.ДатаОбязательнойМаркировки = ДатаНачалаУчетаМаркируемойПродукции(НастройкаУчета.ВидПродукции);
		НастройкаУчета.ДатаОбязательнойМаркировки = СтрокаНабора.ДатаОбязательнойМаркировки;
		
	КонецЕсли;
	
	Если Не ЗначениеЗаполнено(НастройкаУчета.ДатаОбязательногоВключенияРазрешительногоРежима) Тогда
		
		СтрокаНабора.ДатаОбязательногоВключенияРазрешительногоРежима = ДатаНачалаДействияРазрешительногоРежимаНаККТ(НастройкаУчета.ВидПродукции);
		НастройкаУчета.ДатаОбязательногоВключенияРазрешительногоРежима = СтрокаНабора.ДатаОбязательногоВключенияРазрешительногоРежима;
		
	КонецЕсли;
	
	Если НЕ НаборЗаписей.ПроверитьЗаполнение() Тогда
		Отказ = Истина;
		Возврат;
	КонецЕсли;
	
	Попытка
		
		НаборЗаписей.Записать(Истина);
		
		Если НаборЗаписей.ДополнительныеСвойства.Свойство("ЗапуститьФоновоеОбновлениеНастроекРазрешительногоРежима")
			И НаборЗаписей.ДополнительныеСвойства.ЗапуститьФоновоеОбновлениеНастроекРазрешительногоРежима Тогда
			ЗапуститьФоновоеОбновлениеНастроекРазрешительногоРежима = НаборЗаписей.ДополнительныеСвойства.ЗапуститьФоновоеОбновлениеНастроекРазрешительногоРежима;
		КонецЕсли;
		
	Исключение
		ОбщегоНазначения.СообщитьПользователю(КраткоеПредставлениеОшибки(ИнформацияОбОшибке()),,,, Отказ);
	КонецПопытки;
	
КонецПроцедуры

// Возвращает признак - ведется ли в программе учет продукции, требующей обязательной онлайн проверки.
// 
// Возвращаемое значение:
//  Булево - Признак, что в программе ведется учет продукции, требующей обязательной онлайн проверки
Функция ВедетсяУчетПродукцииТребующейОбязательнойОнлайнПроверки() Экспорт
	
	МассивТГОбязательнойОнлайнПроверки = ОбщегоНазначенияИСМПКлиентСерверПовтИсп.ВидыПродукцийОбязательнойОнлайнПроверкиПередРозничнойПродажей();
	
	Запрос = Новый Запрос;
	Запрос.Текст =
		"ВЫБРАТЬ
		|	НастройкиУчетаМаркируемойПродукцииИСМП.ВидПродукции
		|ИЗ
		|	РегистрСведений.НастройкиУчетаМаркируемойПродукцииИСМП КАК НастройкиУчетаМаркируемойПродукцииИСМП
		|ГДЕ
		|	НастройкиУчетаМаркируемойПродукцииИСМП.ВестиУчетПродукции
		|	И НастройкиУчетаМаркируемойПродукцииИСМП.ВидПродукции В (&СписокОбязательнойПроверкиТГ)";
	
	Запрос.УстановитьПараметр("СписокОбязательнойПроверкиТГ", МассивТГОбязательнойОнлайнПроверки);
	
	РезультатЗапроса = Запрос.Выполнить();
	Возврат Не РезультатЗапроса.Пустой();
	
КонецФункции

// Возвращает список учитываемых в программе товарных групп, требующих согласно № 381-ФЗ "Об основах торговой деятельности 
//   в Российской Федерации" обязательного учета в ГИС МТ при розничной продаже
// 
// Возвращаемое значение:
//  СписокЗначений из ПеречислениеСсылка.ВидыПродукцииИС - Список учитываемой продукции, требующей обязательной проверки при продаже в розницу
Функция СписокУчитываемойПродукцииТребующейОбязательнойПроверкиПриПродажеВРозницу() Экспорт
	
	СписокПродукции                    = Новый СписокЗначений();
	МассивТГОбязательнойОнлайнПроверки = ОбщегоНазначенияИСМПКлиентСерверПовтИсп.ВидыПродукцийОбязательнойОнлайнПроверкиПередРозничнойПродажей();
	
	Запрос = Новый Запрос;
	Запрос.Текст =
		"ВЫБРАТЬ
		|	НастройкиУчетаМаркируемойПродукцииИСМП.ВидПродукции                КАК ВидПродукции,
		|	ПРЕДСТАВЛЕНИЕ(НастройкиУчетаМаркируемойПродукцииИСМП.ВидПродукции) КАК Представление
		|ИЗ
		|	РегистрСведений.НастройкиУчетаМаркируемойПродукцииИСМП КАК НастройкиУчетаМаркируемойПродукцииИСМП
		|ГДЕ
		|	НастройкиУчетаМаркируемойПродукцииИСМП.ВестиУчетПродукции
		|	И НастройкиУчетаМаркируемойПродукцииИСМП.ВидПродукции В (&СписокОбязательнойПроверкиТГ)";
	
	Запрос.УстановитьПараметр("СписокОбязательнойПроверкиТГ", МассивТГОбязательнойОнлайнПроверки);
	
	РезультатЗапроса       = Запрос.Выполнить();
	ВыборкаДетальныеЗаписи = РезультатЗапроса.Выбрать();
	
	Пока ВыборкаДетальныеЗаписи.Следующий() Цикл
		СписокПродукции.Добавить(ВыборкаДетальныеЗаписи.ВидПродукции, ВыборкаДетальныеЗаписи.Представление);
	КонецЦикла;
	
	СписокПродукции.СортироватьПоПредставлению();
	
	Возврат СписокПродукции;
	
КонецФункции

// Возвращает список товарных групп для обязательной проверки разрешительного режима
//  при розничной продажи на конкретную дату
// 
// Параметры:
//  НаДату - Дата - дата проверки
// 
// Возвращаемое значение:
//  Массив из ПеречислениеСсылка.ВидыПродукцииИС
Функция СписокУчитываемойПродукцииТребующейОбязательнойПроверкиПриПродажеВРозницуНаДату(НаДату = Неопределено) Экспорт
	
	МассивПродукции = Новый Массив();
	
	Если НаДату = Неопределено Тогда
		НаДату = ТекущаяДатаСеанса();
	КонецЕсли;
	
	Запрос = Новый Запрос;
	Запрос.Текст =
		"ВЫБРАТЬ
		|	НастройкиУчетаМаркируемойПродукцииИСМП.ВидПродукции
		|ИЗ
		|	РегистрСведений.НастройкиУчетаМаркируемойПродукцииИСМП КАК НастройкиУчетаМаркируемойПродукцииИСМП
		|ГДЕ
		|	НастройкиУчетаМаркируемойПродукцииИСМП.ВестиУчетПродукции
		|	И НастройкиУчетаМаркируемойПродукцииИСМП.ВидПродукции В (&СписокПродукцииОбязательнойПроверки)
		|	И ВЫБОР
		|		КОГДА &НаДату = НЕОПРЕДЕЛЕНО
		|			ТОГДА ИСТИНА
		|		ИНАЧЕ НастройкиУчетаМаркируемойПродукцииИСМП.ДатаОбязательногоВключенияРазрешительногоРежима <= &НаДату
		|		И НЕ НастройкиУчетаМаркируемойПродукцииИСМП.ДатаОбязательногоВключенияРазрешительногоРежима = ДАТАВРЕМЯ(1, 1, 1)
		|	КОНЕЦ";
	
	Запрос.УстановитьПараметр("НаДату",                              НаДату);
	Запрос.УстановитьПараметр("СписокПродукцииОбязательнойПроверки", ОбщегоНазначенияИСМПКлиентСерверПовтИсп.ВидыПродукцийОбязательнойОнлайнПроверкиПередРозничнойПродажей());
	
	РезультатЗапроса = Запрос.Выполнить();
	
	ВыборкаДетальныеЗаписи = РезультатЗапроса.Выбрать();
	
	Пока ВыборкаДетальныеЗаписи.Следующий() Цикл
		МассивПродукции.Добавить(ВыборкаДетальныеЗаписи.ВидПродукции);
	КонецЦикла;
	
	Возврат МассивПродукции;
	
КонецФункции

#Область ОбновлениеИнформационнойБазы

Процедура ЗарегистрироватьДанныеКОбработкеДляПереходаНаНовуюВерсиюДатыОбязательнойМаркировки(Параметры) Экспорт
	
	Запрос = Новый Запрос();
	Запрос.Текст = "ВЫБРАТЬ
	|	ВидыПродукцииИС.Ссылка КАК ВидПродукции
	|ИЗ
	|	Перечисление.ВидыПродукцииИС КАК ВидыПродукцииИС
	|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.НастройкиУчетаМаркируемойПродукцииИСМП КАК НастройкиУчетаМаркируемойПродукцииИСМП
	|		ПО НастройкиУчетаМаркируемойПродукцииИСМП.ВидПродукции = ВидыПродукцииИС.Ссылка
	|ГДЕ
	|	НастройкиУчетаМаркируемойПродукцииИСМП.ВидПродукции ЕСТЬ NULL
	|	И ВидыПродукцииИС.Ссылка В (&ВидыПродукцииИСМП)";
	Запрос.УстановитьПараметр("ВидыПродукцииИСМП", ОбщегоНазначенияИСКлиентСервер.ВидыПродукцииИСМП(Истина));
	ТаблицаИзмерений = Запрос.Выполнить().Выгрузить();
	
	ДополнительныеПараметры = ОбновлениеИнформационнойБазы.ДополнительныеПараметрыОтметкиОбработки();
	ДополнительныеПараметры.ПолноеИмяРегистра = "РегистрСведений.НастройкиУчетаМаркируемойПродукцииИСМП";
	ДополнительныеПараметры.ЭтоНезависимыйРегистрСведений = Истина;
	
	ОбновлениеИнформационнойБазы.ОтметитьКОбработке(Параметры, ТаблицаИзмерений, ДополнительныеПараметры);
	
КонецПроцедуры

Процедура ЗарегистрироватьДанныеКОбработкеДляПереходаНаНовуюВерсиюРазрешительныйРежим(Параметры) Экспорт
	
	Запрос = Новый Запрос();
	Запрос.Текст = "ВЫБРАТЬ
	|	ВидыПродукцииИС.Ссылка КАК ВидПродукции
	|ИЗ
	|	Перечисление.ВидыПродукцииИС КАК ВидыПродукцииИС
	|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.НастройкиУчетаМаркируемойПродукцииИСМП КАК НастройкиУчетаМаркируемойПродукцииИСМП
	|		ПО НастройкиУчетаМаркируемойПродукцииИСМП.ВидПродукции = ВидыПродукцииИС.Ссылка
	|ГДЕ
	|	ЕСТЬNULL(НастройкиУчетаМаркируемойПродукцииИСМП.ДатаОбязательногоВключенияРазрешительногоРежима, ДАТАВРЕМЯ(1, 1,
	|		1)) = ДАТАВРЕМЯ(1, 1, 1)
	|	И ВидыПродукцииИС.Ссылка В (&ВидыПродукцииИСМП)";
	Запрос.УстановитьПараметр("ВидыПродукцииИСМП", ОбщегоНазначенияИСМПКлиентСерверПовтИсп.ВидыПродукцийОбязательнойОнлайнПроверкиПередРозничнойПродажей());
	ТаблицаИзмерений = Запрос.Выполнить().Выгрузить();
	
	ДополнительныеПараметры = ОбновлениеИнформационнойБазы.ДополнительныеПараметрыОтметкиОбработки();
	ДополнительныеПараметры.ПолноеИмяРегистра = "РегистрСведений.НастройкиУчетаМаркируемойПродукцииИСМП";
	ДополнительныеПараметры.ЭтоНезависимыйРегистрСведений = Истина;
	
	ОбновлениеИнформационнойБазы.ОтметитьКОбработке(Параметры, ТаблицаИзмерений, ДополнительныеПараметры);
	
КонецПроцедуры

Процедура ОбработатьДанныеДляПереходаНаНовуюВерсиюДатыОбязательнойМаркировки(Параметры) Экспорт
	
	ПолноеИмяРегистра  = "РегистрСведений.НастройкиУчетаМаркируемойПродукцииИСМП";
	МетаданныеРегистра = Метаданные.РегистрыСведений.НастройкиУчетаМаркируемойПродукцииИСМП;
	
	ДополнительныеПараметры = ОбновлениеИнформационнойБазы.ДополнительныеПараметрыОтметкиОбработки();
	ДополнительныеПараметры.ПолноеИмяРегистра             = ПолноеИмяРегистра;
	ДополнительныеПараметры.ЭтоНезависимыйРегистрСведений = Истина;
	
	Выборка = ОбновлениеИнформационнойБазы.ВыбратьИзмеренияНезависимогоРегистраСведенийДляОбработки(Параметры.Очередь, ПолноеИмяРегистра);
	
	Пока Выборка.Следующий() Цикл
		
		НачатьТранзакцию();
		
		Попытка
			
			Блокировка = Новый БлокировкаДанных;
			ЭлементБлокировки = Блокировка.Добавить(ПолноеИмяРегистра);
			ЭлементБлокировки.УстановитьЗначение("ВидПродукции", Выборка.ВидПродукции);
			ЭлементБлокировки.Режим = РежимБлокировкиДанных.Исключительный;
			Блокировка.Заблокировать();
			
			НаборЗаписей = СоздатьНаборЗаписей();
			НаборЗаписей.Отбор["ВидПродукции"].Установить(Выборка.ВидПродукции);
			НаборЗаписей.Прочитать();
			
			Если НаборЗаписей.Количество() = 0 Тогда
				НоваяСтрока = НаборЗаписей.Добавить();
				НоваяСтрока.ВидПродукции               = Выборка.ВидПродукции;
				НоваяСтрока.ДатаОбязательнойМаркировки = ДатаНачалаУчетаМаркируемойПродукции(Выборка.ВидПродукции);
			КонецЕсли;
			
			Если НаборЗаписей.Модифицированность() Тогда
				ОбновлениеИнформационнойБазы.ЗаписатьНаборЗаписей(НаборЗаписей);
			Иначе
				ОбновлениеИнформационнойБазы.ОтметитьВыполнениеОбработки(НаборЗаписей, ДополнительныеПараметры);
			КонецЕсли;
			
			ЗафиксироватьТранзакцию();
			
		Исключение
			
			ОтменитьТранзакцию();
			
			ТекстСообщения = НСтр("ru = 'Не удалось дату начала обязательной маркировки по виду продукции: %1 по причине: %2'");
			ТекстСообщения = СтрШаблон(ТекстСообщения, Выборка.ВидПродукции, ПодробноеПредставлениеОшибки(ИнформацияОбОшибке()));
			ЗаписьЖурналаРегистрации(ОбновлениеИнформационнойБазы.СобытиеЖурналаРегистрации(),
				УровеньЖурналаРегистрации.Предупреждение, МетаданныеРегистра,, ТекстСообщения);
			ВызватьИсключение;
			
		КонецПопытки;
		
	КонецЦикла;
	
	Параметры.ОбработкаЗавершена = Не ОбновлениеИнформационнойБазы.ЕстьДанныеДляОбработки(Параметры.Очередь, ПолноеИмяРегистра);
	
КонецПроцедуры

Процедура ОбработатьДанныеДляПереходаНаНовуюВерсиюРазрешительныйРежим(Параметры) Экспорт
	
	ПолноеИмяРегистра  = "РегистрСведений.НастройкиУчетаМаркируемойПродукцииИСМП";
	МетаданныеРегистра = Метаданные.РегистрыСведений.НастройкиУчетаМаркируемойПродукцииИСМП;
	
	ДополнительныеПараметры = ОбновлениеИнформационнойБазы.ДополнительныеПараметрыОтметкиОбработки();
	ДополнительныеПараметры.ПолноеИмяРегистра             = ПолноеИмяРегистра;
	ДополнительныеПараметры.ЭтоНезависимыйРегистрСведений = Истина;
	
	Выборка = ОбновлениеИнформационнойБазы.ВыбратьИзмеренияНезависимогоРегистраСведенийДляОбработки(Параметры.Очередь, ПолноеИмяРегистра);
	
	Пока Выборка.Следующий() Цикл
		
		НачатьТранзакцию();
		
		Попытка
			
			Блокировка = Новый БлокировкаДанных;
			ЭлементБлокировки = Блокировка.Добавить(ПолноеИмяРегистра);
			ЭлементБлокировки.УстановитьЗначение("ВидПродукции", Выборка.ВидПродукции);
			ЭлементБлокировки.Режим = РежимБлокировкиДанных.Исключительный;
			Блокировка.Заблокировать();
			
			НаборЗаписей = СоздатьНаборЗаписей();
			НаборЗаписей.Отбор["ВидПродукции"].Установить(Выборка.ВидПродукции);
			НаборЗаписей.Прочитать();
			
			Если НаборЗаписей.Количество() = 0 Тогда
				НоваяСтрока = НаборЗаписей.Добавить();
				НоваяСтрока.ВидПродукции                                    = Выборка.ВидПродукции;
				НоваяСтрока.ДатаОбязательнойМаркировки                      = ДатаНачалаУчетаМаркируемойПродукции(Выборка.ВидПродукции);
				НоваяСтрока.ДатаОбязательногоВключенияРазрешительногоРежима = ДатаНачалаДействияРазрешительногоРежимаНаККТ(Выборка.ВидПродукции);
			Иначе
				НоваяСтрока = НаборЗаписей[0];
				НоваяСтрока.ДатаОбязательногоВключенияРазрешительногоРежима = ДатаНачалаДействияРазрешительногоРежимаНаККТ(Выборка.ВидПродукции);
			КонецЕсли;
			
			Если НаборЗаписей.Модифицированность() Тогда
				ОбновлениеИнформационнойБазы.ЗаписатьНаборЗаписей(НаборЗаписей);
			Иначе
				ОбновлениеИнформационнойБазы.ОтметитьВыполнениеОбработки(НаборЗаписей, ДополнительныеПараметры);
			КонецЕсли;
			
			ЗафиксироватьТранзакцию();
			
		Исключение
			
			ОтменитьТранзакцию();
			
			ТекстСообщения = НСтр("ru = 'Не удалось дату начала действия разрешительного режима розничной продажи по виду продукции: %1 по причине: %2'");
			ТекстСообщения = СтрШаблон(ТекстСообщения, Выборка.ВидПродукции, ПодробноеПредставлениеОшибки(ИнформацияОбОшибке()));
			ЗаписьЖурналаРегистрации(ОбновлениеИнформационнойБазы.СобытиеЖурналаРегистрации(),
				УровеньЖурналаРегистрации.Предупреждение, МетаданныеРегистра,, ТекстСообщения);
			ВызватьИсключение;
			
		КонецПопытки;
		
	КонецЦикла;
	
	Параметры.ОбработкаЗавершена = Не ОбновлениеИнформационнойБазы.ЕстьДанныеДляОбработки(Параметры.Очередь, ПолноеИмяРегистра);
	
КонецПроцедуры

#КонецОбласти

#КонецОбласти

#КонецЕсли