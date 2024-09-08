﻿#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("АвтоТест") Тогда
		Возврат;
	КонецЕсли;
		
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	СтатусВыполненнойЗагрузки = Ложь;
	
	// Устанавливаем текущую таблицу переходов
	ТаблицаПереходовПоСценарию();
	
	// Позиционируемся на первом шаге помощника
	УстановитьПорядковыйНомерПерехода(1);
	
	#Если ВебКлиент Тогда
		Отказ = Истина;
		ПоказатьПредупреждение(, НСтр("ru='Обработка не предназначена для работы в режиме веб-клиента'"));
		Возврат;
	#КонецЕсли
	
КонецПроцедуры

&НаКлиенте
Процедура ПриЗакрытии(ЗавершениеРаботы)
	
	Если ЗавершениеРаботы Тогда
		Возврат;
	КонецЕсли;
	
	ОбновитьИнтерфейс();
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ИмяФайлаОбменаНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	ВыбранФайлОбмена = Ложь;
	Режим = РежимДиалогаВыбораФайла.Открытие;
	ДиалогОткрытияФайла = Новый ДиалогВыбораФайла(Режим);
	Фильтр = НСтр("ru = 'Файл выгрузки (*.xml)|*.xml'");
	ДиалогОткрытияФайла.Фильтр = Фильтр;
	ДиалогОткрытияФайла.МножественныйВыбор = Ложь;
	ДиалогОткрытияФайла.Заголовок = НСтр("ru = 'Выберите путь к файлу выгрузки данных из ТиС'");
	ОписаниеОповещения = Новый ОписаниеОповещения("ПослеВыбораФайлаОбменаИзТонкогоКлиента", ЭтотОбъект);
	ДиалогОткрытияФайла.Показать(ОписаниеОповещения);
		
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура КомандаДалее(Команда)
	
	ИзменитьПорядковыйНомерПерехода(+1);
	
	Если Элементы.ПанельОсновная.ТекущаяСтраница = Элементы.СтраницаОжидания Тогда
		
		ПодключитьОбработчикОжидания("ОбработчикОжиданияКомандаДалее", 0.1, Истина);
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура КомандаНазад(Команда)
	
	ИзменитьПорядковыйНомерПерехода(-1);
	
КонецПроцедуры

&НаКлиенте
Процедура КомандаГотово(Команда)
	
	Закрыть();
	
КонецПроцедуры

&НаКлиенте
Процедура КомандаОтмена(Команда)
	
	Закрыть();
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработчикОжиданияКомандаДалее()
	
	КомандаДалее(Неопределено);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

#Область ИнициализацияПереходовПомощника

// Процедура определяет таблицу переходов по сценарию №1.
// Для заполнения таблицы переходов используется процедура ТаблицаПереходовНоваяСтрока().
//
&НаКлиенте
Процедура ТаблицаПереходовПоСценарию()
	
	ТаблицаПереходов.Очистить();
	СтруктураПараметров = СоздатьСтруктуруПараметровСтрокиПерехода("СтраницаНачало", 
									"СтраницаНавигацииНачало", "СтраницаНачало_ПриОткрытии");
	СтруктураПараметров.ИмяОбработчикаПриПереходеДалее = "СтраницаНачало_ПриПереходеДалее";
	СтруктураПараметров.ИмяСтраницыДекорации = "СтраницаДекорацииНачало";
	ТаблицаПереходовНоваяСтрока(1, СтруктураПараметров);
	
	СтруктураПараметров = СоздатьСтруктуруПараметровСтрокиПерехода("СтраницаОжидания", 
									"СтраницаНавигацииОжидание", "СтраницаОжидания_ПриОткрытии");
	СтруктураПараметров.ИмяОбработчикаПриПереходеДалее = "СтраницаОжидания_ПриПереходеДалее";
	СтруктураПараметров.ИмяСтраницыДекорации = "СтраницаДекорацииОжидание";
	ТаблицаПереходовНоваяСтрока(2, СтруктураПараметров);
	
	СтруктураПараметров = СоздатьСтруктуруПараметровСтрокиПерехода("СтраницаОкончание", 
									"СтраницаНавигацииОкончание", "СтраницаОкончание_ПриОткрытии");
	СтруктураПараметров.ИмяСтраницыДекорации = "СтраницаДекорацииОкончание";
	ТаблицаПереходовНоваяСтрока(3, СтруктураПараметров);
	
КонецПроцедуры

// Готовит структуру параметров для дальнейшего добавления строки в таблицу переходов.
//
// Параметры:
//
//  	ИмяОсновнойСтраницы - Строка. Имя страницы панели "ПанельОсновная", 
//		которая соответствует текущему номеру перехода.
//
//  	ИмяСтраницыНавигации - Строка. Имя страницы панели "ПанельНавигации", 
//		которая соответствует текущему номеру перехода.
//
//  	ИмяОбработчикаПриОткрытии - Строка. Имя функции-обработчика события открытия текущей страницы 
//  	помощника
&НаКлиенте
Функция СоздатьСтруктуруПараметровСтрокиПерехода(ИмяОсновнойСтраницы, ИмяСтраницыНавигации, ИмяОбработчикаПриОткрытии)
	СтруктураПараметров = Новый Структура();
	СтруктураПараметров.Вставить("ИмяОсновнойСтраницы", ИмяОсновнойСтраницы);
	СтруктураПараметров.Вставить("ИмяСтраницыНавигации", ИмяСтраницыНавигации);
	СтруктураПараметров.Вставить("ИмяСтраницыДекорации", "");
	СтруктураПараметров.Вставить("ИмяОбработчикаПриОткрытии", ИмяОбработчикаПриОткрытии);
	СтруктураПараметров.Вставить("ИмяОбработчикаПриПереходеДалее", "");
	СтруктураПараметров.Вставить("ИмяОбработчикаПриПереходеНазад", "");
	Возврат СтруктураПараметров;
КонецФункции

// Добавляет новую строку в конец текущей таблицы переходов
//
// Параметры:
//
//  ПорядковыйНомерПерехода (обязательный) - Число. Порядковый номер перехода, который соответствует текущему шагу 
//  перехода
//  СтруктураПараметров - Структура, содержащая значения колонок в строке таблицы переходов
//  	ИмяОсновнойСтраницы - Строка. Имя страницы панели "ПанельОсновная", 
//		которая соответствует текущему номеру перехода.
//
//  	ИмяСтраницыНавигации - Строка. Имя страницы панели "ПанельНавигации", 
//		которая соответствует текущему номеру перехода.
//
//  	ИмяСтраницыДекорации - Строка. Имя страницы панели "ПанельДекорации", которая соответствует 
//  	текущему номеру перехода.
//
//  	ИмяОбработчикаПриОткрытии - Строка. Имя функции-обработчика события открытия текущей страницы 
//  	помощника
//
//  	ИмяОбработчикаПриПереходеДалее - Строка. Имя функции-обработчика события перехода на следующую 
//  	страницу помощника.
//
//  	ИмяОбработчикаПриПереходеНазад - Строка. Имя функции-обработчика события перехода на предыдущую 
//  	страницу помощника.
// 
&НаСервере
Процедура ТаблицаПереходовНоваяСтрока(ПорядковыйНомерПерехода, СтруктураПараметров)
	
	НоваяСтрока = ТаблицаПереходов.Добавить();
	
	НоваяСтрока.ПорядковыйНомерПерехода = ПорядковыйНомерПерехода;
	ЗаполнитьЗначенияСвойств(НоваяСтрока, СтруктураПараметров);
КонецПроцедуры

&НаКлиенте
Процедура ИзменитьПорядковыйНомерПерехода(Итератор)
	
	УстановитьПорядковыйНомерПерехода(ПорядковыйНомерПерехода + Итератор);
	
КонецПроцедуры

&НаКлиенте
Процедура УстановитьПорядковыйНомерПерехода(Знач Значение)
	
	ЭтоПереходДалее = (Значение > ПорядковыйНомерПерехода);
	
	ПорядковыйНомерПерехода = Значение;
	
	Если ПорядковыйНомерПерехода < 0 Тогда
		
		ПорядковыйНомерПерехода = 0;
		
	КонецЕсли;
	
	ПорядковыйНомерПереходаПриИзменении(ЭтоПереходДалее);
	
КонецПроцедуры

&НаКлиенте
Процедура ПорядковыйНомерПереходаПриИзменении(Знач ЭтоПереходДалее)
	
	// Обработчики событий переходов
	Если ЭтоПереходДалее Тогда
		
		СтрокиПерехода = ТаблицаПереходов.НайтиСтроки(Новый Структура("ПорядковыйНомерПерехода", ПорядковыйНомерПерехода - 1));
		
		Если СтрокиПерехода.Количество() = 0 Тогда
			Возврат;
		КонецЕсли;
		
		СтрокаПерехода = СтрокиПерехода[0];
		
		// обработчик ПриПереходеДалее
		Если Не ПустаяСтрока(СтрокаПерехода.ИмяОбработчикаПриПереходеДалее) Тогда
			
			ИмяПроцедуры = "Подключаемый_[ИмяОбработчика](Отказ)";
			ИмяПроцедуры = СтрЗаменить(ИмяПроцедуры, "[ИмяОбработчика]", СтрокаПерехода.ИмяОбработчикаПриПереходеДалее);
			
			Отказ = Ложь;
			
			Попытка
				Выполнить(ИмяПроцедуры);
			Исключение
				Отказ = Истина;
			КонецПопытки;
			
			Если Отказ Тогда
				
				УстановитьПорядковыйНомерПерехода(ПорядковыйНомерПерехода - 1);
				
				Возврат;
				
			КонецЕсли;
			
		КонецЕсли;
		
	Иначе
		
		СтрокиПерехода = ТаблицаПереходов.НайтиСтроки(Новый Структура("ПорядковыйНомерПерехода", ПорядковыйНомерПерехода + 1));
		
		Если СтрокиПерехода.Количество() = 0 Тогда
			Возврат;
		КонецЕсли;
		
		СтрокаПерехода = СтрокиПерехода[0];
		
		// обработчик ПриПереходеНазад
		Если Не ПустаяСтрока(СтрокаПерехода.ИмяОбработчикаПриПереходеНазад) Тогда
			
			ИмяПроцедуры = "Подключаемый_[ИмяОбработчика](Отказ)";
			ИмяПроцедуры = СтрЗаменить(ИмяПроцедуры, "[ИмяОбработчика]", СтрокаПерехода.ИмяОбработчикаПриПереходеНазад);
			
			Отказ = Ложь;
			
			Попытка
				Выполнить(ИмяПроцедуры);
			Исключение
				Отказ = Истина;
			КонецПопытки;

			
			Если Отказ Тогда
				
				УстановитьПорядковыйНомерПерехода(ПорядковыйНомерПерехода + 1);
				
				Возврат;
				
			КонецЕсли;
			
		КонецЕсли;
		
	КонецЕсли;
	
	СтрокиПереходаТекущие = ТаблицаПереходов.НайтиСтроки(Новый Структура("ПорядковыйНомерПерехода", ПорядковыйНомерПерехода));
	
	Если СтрокиПереходаТекущие.Количество() = 0 Тогда
		Возврат;
	КонецЕсли;
	
	СтрокаПереходаТекущая = СтрокиПереходаТекущие[0];
	// обработчик ПриОткрытии
	Если Не ПустаяСтрока(СтрокаПереходаТекущая.ИмяОбработчикаПриОткрытии) Тогда
		
		ИмяПроцедуры = "Подключаемый_[ИмяОбработчика](Отказ, ПропуститьСтраницу, ЭтоПереходДалее)";
		ИмяПроцедуры = СтрЗаменить(ИмяПроцедуры, "[ИмяОбработчика]", СтрокаПереходаТекущая.ИмяОбработчикаПриОткрытии);
		
		Отказ = Ложь;
		ПропуститьСтраницу = Ложь;
		
		Попытка
			Выполнить(ИмяПроцедуры);
		Исключение
			Отказ = Истина;
		КонецПопытки;
		
		Если Отказ Тогда
			
			УстановитьПорядковыйНомерПерехода(ПорядковыйНомерПерехода - 1);
			
			Возврат;
			
		ИначеЕсли ПропуститьСтраницу Тогда
			
			Если ЭтоПереходДалее Тогда
				
				УстановитьПорядковыйНомерПерехода(ПорядковыйНомерПерехода + 1);
				
				Возврат;
				
			Иначе
				
				УстановитьПорядковыйНомерПерехода(ПорядковыйНомерПерехода - 1);
				
				Возврат;
				
			КонецЕсли;
			
		КонецЕсли;
		
	КонецЕсли;
	
	// Установка отображения текущей страницы
	Элементы.ПанельОсновная.ТекущаяСтраница  = Элементы[СтрокаПереходаТекущая.ИмяОсновнойСтраницы];
	Элементы.ПанельНавигации.ТекущаяСтраница = Элементы[СтрокаПереходаТекущая.ИмяСтраницыНавигации];
	
	Если Не ПустаяСтрока(СтрокаПереходаТекущая.ИмяСтраницыДекорации) Тогда
		
		Элементы.ПанельДекорации.ТекущаяСтраница = Элементы[СтрокаПереходаТекущая.ИмяСтраницыДекорации];
		
	КонецЕсли;
	
	// Устанавливаем текущую кнопку по умолчанию
	КнопкаДалее = ПолучитьКнопкуФормыПоИмениКоманды(Элементы.ПанельНавигации.ТекущаяСтраница, "КомандаДалее");
	
	Если КнопкаДалее <> Неопределено Тогда
		
		КнопкаДалее.КнопкаПоУмолчанию = Истина;
		
	Иначе
		
		КнопкаГотово = ПолучитьКнопкуФормыПоИмениКоманды(Элементы.ПанельНавигации.ТекущаяСтраница, "КомандаГотово");
		
		Если КнопкаГотово <> Неопределено Тогда
			
			КнопкаГотово.КнопкаПоУмолчанию = Истина;
			
		КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры
#КонецОбласти

#Область ОбработчикиСобытийПерехода
// Обработчик выполняется при открытии страницы помощника "СтраницаНачало"
//
// Параметры:
//
//  Отказ - Булево - флаг отказа от открытия страницы;
//			если в обработчике поднять этот флаг, то переход на страницу выполнен не будет,
//			останется открытой предыдущая страница помощника согласно направлению перехода (вперед или назад).
//
//  ПропуститьСтраницу - Булево. Если поднять этот флаг, то страница будет пропущена
//			и управление перейдет на следующую страницу помощника согласно направлению перехода (вперед или назад).
//
//  ЭтоПереходДалее (только чтение) - Булево - флаг определяет направление перехода.
//			Истина - выполняется переход далее; Ложь - выполняется переход назад.
&НаКлиенте
Процедура Подключаемый_СтраницаНачало_ПриОткрытии(Отказ, ПропуститьСтраницу, Знач ЭтоПереходДалее)
	Элементы.КомандаДалее.КнопкаПоУмолчанию = Истина;
КонецПроцедуры

// Обработчик перехода далее (на следующую страницу) при уходе со страницы помощника "СтраницаНачало".
//
// Параметры:
// Отказ - Булево - флаг отказа от выполнения перехода далее;
//					если в обработчике поднять этот флаг, то переход на следующую страницу выполнен не будет.
//
&НаКлиенте
Процедура Подключаемый_СтраницаНачало_ПриПереходеДалее(Отказ)
	
	// Проверка файла данных
	
	ТекстСообщения = "";
	Если НЕ ЗначениеЗаполнено(Объект.ИмяФайлаОбмена) Тогда
		ТекстСообщения = НСтр("ru = 'Не указан путь к файлу с данными.'");
	Иначе
		ФайлОбмена = Новый Файл(Объект.ИмяФайлаОбмена);
		Оповещение = Новый ОписаниеОповещения("ПроверкаСуществованияФайла", ЭтотОбъект);
		ФайлОбмена.НачатьПроверкуСуществования(Оповещение);
	КонецЕсли;
	
	Если ТекстСообщения <> "" Тогда
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения,,"ИмяФайлаОбмена", "ИмяФайлаОбмена", Отказ);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПроверкаСуществованияФайла(Существует, ДополнительныеПараметры) Экспорт
	
	Если НЕ Существует Тогда
		ТекстСообщения = НСтр("ru = 'По указанному пути файл с данными не найден.'");
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения,,"ИмяФайлаОбмена", "ИмяФайлаОбмена");
	Иначе
		Оповещение = Новый ОписаниеОповещения("ОбработкаЗагрузкиФайла", ЭтотОбъект);
		НачатьПомещениеФайла(Оповещение, АдресВременногоХранилищаФайлаОбмена, Объект.ИмяФайлаОбмена, Ложь, УникальныйИдентификатор);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаЗагрузкиФайла(Результат, Адрес, ВыбранноеИмяФайла, ДополнительныеПараметры) Экспорт
	
	АдресВременногоХранилищаФайлаОбмена = Адрес;
	
КонецПроцедуры

// Обработчик выполняется при открытии страницы помощника "СтраницаОкончание"
//
// Параметры:
//
//  Отказ - Булево - флаг отказа от открытия страницы;
//			если в обработчике поднять этот флаг, то переход на страницу выполнен не будет,
//			останется открытой предыдущая страница помощника согласно направлению перехода (вперед или назад).
//
//  ПропуститьСтраницу - Булево. Если поднять этот флаг, то страница будет пропущена
//			и управление перейдет на следующую страницу помощника согласно направлению перехода (вперед или назад).
//
//  ЭтоПереходДалее (только чтение) - Булево - флаг определяет направление перехода.
//			Истина - выполняется переход далее; Ложь - выполняется переход назад.
//
&НаКлиенте
Процедура Подключаемый_СтраницаОкончание_ПриОткрытии(Отказ, ПропуститьСтраницу, Знач ЭтоПереходДалее)
	
	Элементы.КомандаГотово.КнопкаПоУмолчанию = Истина;
	Элементы.НадписьСтатусЗагрузки.Заголовок = ?(СтатусВыполненнойЗагрузки,
												НСтр("ru = 'Загрузка данных успешно завершена!'"),
												НСтр("ru = 'Загрузка данных выполненна с ошибками!'"));
	Элементы.НадписьВариантовПродолжения.Заголовок = ?(СтатусВыполненнойЗагрузки,
												НСтр("ru = 'Нажмите кнопку ""Готово"" для выхода из помощника.'"),
												НСтр("ru = 'Для того чтобы попробовать загрузить еще раз, нажмите ""Назад""'") + ", "
												+ НСтр("ru = 'для выхода из помошника, нажимите ""Готово""'"));
	
	
	ЗаполнитьИтоговуюИнформацию();
	
КонецПроцедуры

// Обработчик перехода далее (на следующую страницу) при уходе со страницы помощника "СтраницаОжидания".
//
// Параметры:
// Отказ - Булево - флаг отказа от выполнения перехода далее;
//					если в обработчике поднять этот флаг, то переход на следующую страницу выполнен не будет.
//
&НаКлиенте
Процедура Подключаемый_СтраницаОжидания_ПриПереходеДалее(Отказ)
	
	Состояние(НСтр("ru = 'Загрузка данных...'"),, НСтр("ru = 'Выполняется загрузка данных из ТиС'"));
	СтатусВыполненнойЗагрузки = ЗагрузитьНаСервере();
	
КонецПроцедуры

// Обработчик выполняется при открытии страницы помощника "СтраницаОжидания"
//
// Параметры:
//
//  Отказ - Булево - флаг отказа от открытия страницы;
//			если в обработчике поднять этот флаг, то переход на страницу выполнен не будет,
//			останется открытой предыдущая страница помощника согласно направлению перехода (вперед или назад).
//
//  ПропуститьСтраницу - Булево. Если поднять этот флаг, то страница будет пропущена
//			и управление перейдет на следующую страницу помощника согласно направлению перехода (вперед или назад).
//
//  ЭтоПереходДалее (только чтение) - Булево - флаг определяет направление перехода.
//			Истина - выполняется переход далее; Ложь - выполняется переход назад.
//
// Логика данного обработчика пропускает отображение
// страницы помощника "СтраницаОжидания", если выполняется переход назад.
//
&НаКлиенте
Процедура Подключаемый_СтраницаОжидания_ПриОткрытии(Отказ, ПропуститьСтраницу, Знач ЭтоПереходДалее)
	
	Если Не ЭтоПереходДалее Тогда
		
		ПропуститьСтраницу = Истина;
		
	КонецЕсли;
	
КонецПроцедуры
#КонецОбласти

#Область Прочее

&НаКлиенте
Процедура ПослеВыбораФайлаОбменаИзТонкогоКлиента(ВыбранныеФайлы, ДополнительныеПараметры) Экспорт
	
	Если ВыбранныеФайлы = Неопределено ИЛИ НЕ ВыбранныеФайлы.Количество() Тогда
		Объект.ИмяФайлаОбмена = "";
	Иначе
		Объект.ИмяФайлаОбмена = ВыбранныеФайлы[0];
	КонецЕсли;

КонецПроцедуры

&НаКлиенте
Функция ПолучитьКнопкуФормыПоИмениКоманды(ЭлементФормы, ИмяКоманды)
	
	Для Каждого Элемент Из ЭлементФормы.ПодчиненныеЭлементы Цикл
		
		Если ТипЗнч(Элемент) = Тип("ГруппаФормы") Тогда
			
			ЭлементФормыПоИмениКоманды = ПолучитьКнопкуФормыПоИмениКоманды(Элемент, ИмяКоманды);
			
			Если ЭлементФормыПоИмениКоманды <> Неопределено Тогда
				
				Возврат ЭлементФормыПоИмениКоманды;
				
			КонецЕсли;
			
		ИначеЕсли ТипЗнч(Элемент) = Тип("КнопкаФормы")
			И СтрНайти(Элемент.ИмяКоманды, ИмяКоманды) > 0 Тогда
			
			Возврат Элемент;
			
		Иначе
			
			Продолжить;
			
		КонецЕсли;
		
	КонецЦикла;
	
	Возврат Неопределено;
	
КонецФункции

&НаСервере
Функция ЗагрузитьНаСервере()
	
	ДвоичныеДанные = ПолучитьИзВременногоХранилища(АдресВременногоХранилищаФайлаОбмена);
	// получаем имя временного файла в локальной ФС на сервере
	ИмяВременногоФайла = ПолучитьИмяВременногоФайла("xml");
	// получаем файл правил для зачитки
	ДвоичныеДанные.Записать(ИмяВременногоФайла);
	
	Обработка = Обработки.УниверсальныйОбменДаннымиXML.Создать();
	Обработка.ИмяФайлаОбмена                        = ИмяВременногоФайла;
	Обработка.РежимОбмена                           = "Загрузка";
	Обработка.ЗапоминатьЗагруженныеОбъекты          = Ложь;
	
	Обработка.ЗагружатьДанныеВРежимеОбмена              			= Истина;
	Обработка.ОбъектыПоСсылкеЗагружатьБезПометкиУдаления			= Истина;
	Обработка.ОптимизированнаяЗаписьОбъектов            			= Истина;
	Обработка.ЗапоминатьЗагруженныеОбъекты               			= Истина;
	Обработка.НеВыводитьНикакихИнформационныхСообщенийПользователю	= Истина;
	
	ДатаНачалаЗагрузки = ТекущаяДатаСеанса();
	
	УстановитьПривилегированныйРежим(Истина);
	Обработка.ВыполнитьЗагрузку();
	ЗагрузкаВыполнена = НЕ Обработка.ФлагОшибки;
	УстановитьПривилегированныйРежим(Ложь);
	
	Попытка
		УдалитьФайлы(ИмяВременногоФайла);
	Исключение
		ЗаписьЖурналаРегистрации(НСтр("ru = 'Помощник перехода с Торговля и склад.Удаление временных файлов'", ОбщегоНазначенияКлиентСервер.КодОсновногоЯзыка()),
			УровеньЖурналаРегистрации.Ошибка, , , ПодробноеПредставлениеОшибки(ИнформацияОбОшибке()));
	КонецПопытки;
	
	ДатаОкончанияЗагрузки = ТекущаяДатаСеанса();
	
	ЗагруженыНастройки = Ложь;
	Если ЗагрузкаВыполнена
		И ТипЗнч(Обработка.Параметры) = Тип("Структура")
		И Обработка.Параметры.Свойство("ЗагруженыНастройки") Тогда
		ЗагруженыНастройки = Истина;
	КонецЕсли;
	
	Возврат ЗагрузкаВыполнена;
	
КонецФункции

&НаСервере
Процедура ЗаполнитьИтоговуюИнформацию()
	
	
ИмяМакета = ?(ЗагруженыНастройки, "МакетИтоговойИнформацииНастройки", "МакетИтоговойИнформации");
	ИтоговаяИнформация = Обработки.ПомощникПереходаСТорговляИСклад77.ПолучитьМакет(ИмяМакета).ПолучитьТекст();
	
	ИтоговаяИнформация = СтрЗаменить(ИтоговаяИнформация, "#ДатаНачалаЗагрузки#", ДатаНачалаЗагрузки);
	ИтоговаяИнформация = СтрЗаменить(ИтоговаяИнформация, "#ДатаОкончанияЗагрузки#", ДатаОкончанияЗагрузки);
	ИтоговаяИнформация = СтрЗаменить(ИтоговаяИнформация, "#КоличествоЗагруженныхОбъектов#", КоличествоЗагруженныхОбъектов);
	
	Если СтатусВыполненнойЗагрузки Тогда
		
		Если ЗагруженыНастройки Тогда
		
			Запрос = Новый Запрос("ВЫБРАТЬ
			|	Константы.БазоваяВалютаПоУмолчанию,
			|	Константы.ВалютаУправленческогоУчета,
			|	Константы.ДополнительнаяКолонкаПечатныхФормДокументов,
			|	Константы.ИспользоватьЗаказыКлиентов,
			|	Константы.ИспользоватьЗаказыПоставщикам,
			|	Константы.ИспользоватьКомиссиюПриЗакупках,
			|	Константы.ИспользоватьКомиссиюПриПродажах,
			|	Константы.ИспользоватьДоверенностиНаПолучениеТМЦ,
			|	Константы.ИспользоватьКоммерческиеПредложенияКлиентам,
			|	Константы.ИспользоватьРозничныеПродажи,
			|	Константы.ИспользоватьУпаковкиНоменклатуры,
			|	Константы.ИспользоватьДополнительныеРеквизитыИСведения,
			|	Константы.ИспользоватьАвтоматическиеСкидкиВПродажах,
			|	Константы.КонтролироватьОстаткиТоваровОрганизаций,
			|	Константы.ИспользоватьИмпортныеЗакупки,
			|	Константы.ИспользоватьПеремещениеТоваров,
			|	Константы.ИспользоватьСборкуРазборку,
			|	Константы.ИспользоватьСделкиСКлиентами,
			|	Константы.ИспользованиеСоглашенийСКлиентами,
			|	Константы.ИспользоватьПартнеровИКонтрагентов,
			|	Константы.ИспользоватьСтатусыЗаказовПоставщикам,
			|	Константы.ИспользоватьСтатусыПеремещенийТоваров,
			|	Константы.ИспользоватьСтатусыРеализацийТоваровУслуг,
			|	Константы.ИспользоватьСтатусыСборокТоваров,
			|	Константы.ИспользоватьМногооборотнуюТару,
			|	Константы.НеЗакрыватьЗаказыКлиентовБезПолнойОплаты,
			|	Константы.НеЗакрыватьЗаказыКлиентовБезПолнойОтгрузки,
			|	Константы.ИспользоватьПодразделения,
			|	Константы.ИспользоватьНаборы,
			|	Константы.ИспользоватьНесколькоВидовНоменклатуры,
			|	Константы.ИспользоватьДоговорыСКлиентами,
			|	ВЫБОР КОГДА Константы.ИспользоватьПострочнуюОтгрузкуВЗаказеКлиента
			|		И Константы.ИспользоватьРасширенныеВозможностиЗаказаКлиента ТОГДА
			|			&ВариантИспользованияЗаказов1
			|	ИНАЧЕ
			|			&ВариантИспользованияЗаказов2
			|	КОНЕЦ КАК ИспользованиеЗаказов,
			|	Константы.ИспользоватьПричиныОтменыЗаказовКлиентов,
			|	Константы.ИспользоватьДоговорыСПоставщиками,
			|	Константы.НеЗакрыватьЗаказыПоставщикамБезПолнойОплаты,
			|	Константы.НеЗакрыватьЗаказыПоставщикамБезПолногоПоступления
			|ИЗ
			|	Константы КАК Константы");
			
			Запрос.УстановитьПараметр("ВариантИспользованияЗаказов1", НСтр("ru = 'Заказ со склада и под заказ'"));
			Запрос.УстановитьПараметр("ВариантИспользованияЗаказов2", НСтр("ru = 'Заказ как счет'"));
			
			Результат = Запрос.Выполнить().Выгрузить();
			
			Для Каждого Колонка Из Результат.Колонки Цикл
				
				Значение = Результат[0][Колонка.Имя];
				Значение = ?(ТипЗнч(Значение) = Тип("Булево"), Формат(Значение, "БЛ=Выключено; БИ=Включено"), Строка(Значение));
				ИтоговаяИнформация = СтрЗаменить(ИтоговаяИнформация, "#" + Колонка.Имя + "#", Значение);
				
			КонецЦикла;
		
		КонецЕсли;
		
	Иначе
		
		ИтоговаяИнформация = ИтоговаяИнформация + Символы.ПС+ НСтр("ru = 'Протокол ошибок'") + ": ";
		ИтоговаяИнформация = ИтоговаяИнформация + Символы.ПС+ ПротоколОбмена.ПолучитьТекст();

	КонецЕсли;
	
КонецПроцедуры
#КонецОбласти
#КонецОбласти

